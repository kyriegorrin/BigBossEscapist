# echo_title() outputs a title to stdout and MY_OUTPUT
function echo_title() {
	echo "> $1"
	echo "<h1>$1</h1>" >> "$MY_OUTPUT"
}

# echo_step() outputs a step to stdout and MY_OUTPUT
function echo_step() {
	echo "    > $1"
	echo "<h2>$1</h2>" >> "$MY_OUTPUT"
}

# echo_sub_step() outputs a step to stdout and MY_OUTPUT
function echo_sub_step() {
	echo "      > $1"
	echo "<h3>$1</h3>" >> "$MY_OUTPUT"
}

# echo_code() outputs <pre> or </pre> to MY_OUTPUT
function echo_code() {
	case "$1" in
		start)
			echo "<pre>" >> "$MY_OUTPUT"
			;;
		end)
			echo "</pre>" >> "$MY_OUTPUT"
			;;
	esac
}

# echo_equals() outputs a line with =
function echo_equals() {
	COUNTER=0
	while [  $COUNTER -lt "$1" ]; do
		printf '='
		let COUNTER=COUNTER+1 
	done
}

# echo_line() outputs a line with 70 =
function echo_line() {
	echo_equals "70"
	echo
}

# exit_with_failure() outputs a message before exiting the script.
function exit_with_failure() {
	echo
	echo "FAILURE: $1"
	echo
	exit 9
}

#####################################################################
# Other helpers
#####################################################################

# command_exists() tells if a given command exists.
function command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# perl_module_exists() tells if a given perl module exists.
function perl_module_exists() {
	perl -M"$1" -e 1 >/dev/null 2>&1
}

# check_if_root_or_die() verifies if the script is being run as root and exits
# otherwise (i.e. die).
function check_if_root_or_die() {
	SCRIPT_UID=$(id -u)
	if [ "$SCRIPT_UID" != 0 ]; then
		exit_with_failure "$ME should be run as root"
	fi
}

# check_operating_system() obtains the operating system and exits if it's not testet
function check_operating_system() {
	MY_UNAME_S="$(uname -s 2>/dev/null)"
	if [ "$MY_UNAME_S" = "Linux" ]; then
		echo "    > Operating System: Linux"
	else
		exit_with_failure "Unsupported operating system 'MY_UNAME_S'. Please use 'Linux' or edit this script :-)"
	fi
}

# hostname_fqdn() get full (FQDN) hostname
function hostname_fqdn() {
	echo_step "Hostname (FQDN)"
	if hostname -f &>/dev/null; then
		hostname -f >> "$MY_OUTPUT"
	elif hostname &>/dev/null; then
		hostname >> "$MY_OUTPUT"
	else
		echo "Hostname could not be determined"
	fi
}

# cpu_info() cat /proc/cpuinfo to MY_OUTPUT
function cpu_info() {
	echo_step "CPU Info"
	if [[ -f "/proc/cpuinfo" ]]; then
		MY_CPU_COUNT=$(grep -c processor /proc/cpuinfo)
		echo_code start
		cat "/proc/cpuinfo" >> "$MY_OUTPUT"
		echo_code end
	else
		exit_with_failure "'/proc/cpuinfo' does not exist"
	fi
}

# mem_info() cat /proc/meminfo to MY_OUTPUT
function mem_info() {
	echo_step "RAM Info"
	if [[ -f "/proc/meminfo" ]]; then
		echo_code start
		cat "/proc/meminfo" >> "$MY_OUTPUT"
		echo_code end
	else
		exit_with_failure "'/proc/meminfo' does not exist"
	fi
	
	echo_step "Free"
	echo_code start
	free -m >> "$MY_OUTPUT"
	echo_code end
}

# network_info() cat /etc/resolv.conf to MY_OUTPUT
function network_info() {
	echo_step "Network Card"
	echo_code start
	lspci -nnk | grep -i net -A2 >> "$MY_OUTPUT"
	echo_code end
	
	echo_step "Ifconfig"
	echo_code start
	ifconfig >> "$MY_OUTPUT"
	echo_code end
	
	echo_step "Nameserver"
	if [[ -f "/etc/resolv.conf" ]]; then
		echo_code start
		cat "/etc/resolv.conf" >> "$MY_OUTPUT"
		echo_code end
	else
		exit_with_failure "'/etc/resolv.conf' does not exist"
	fi
}

# disk_info() df -h to MY_OUTPUT
function disk_info() {
	echo_step "Disk Info"
	echo_code start
	df -h >> "$MY_OUTPUT"
	echo_code end
}

# traceroute_benchmark() traceroute to MY_OUTPUT
function traceroute_benchmark() {
	echo_step "Traceroute ($1)"
	echo_code start
	traceroute "$1" >> "$MY_OUTPUT" 2>&1
	echo_code end
}

# ping_benchmark() ping to MY_OUTPUT
function ping_benchmark() {
	echo_step "Ping ($1)"
	echo_code start
	ping -c 10 "$1" >> "$MY_OUTPUT" 2>&1
	echo_code end
}

# download_benchmark() curl speed to MY_OUTPUT
function download_benchmark() {
	echo_step "Download from $1 ($2)"
	
	if MY_CURL_STATS=$(curl -f -w '%{speed_download}\t%{time_namelookup}\t%{time_total}\n' -o /dev/null -s "$2"); then
		MY_CURL_SPEED=$(echo "$MY_CURL_STATS" | awk '{print $1}')
		MY_CURL_DNSTIME=$(echo "$MY_CURL_STATS" | awk '{print $2}')
		MY_CURL_TOTALTIME=$(echo "$MY_CURL_STATS" | awk '{print $3}')
		echo_code start
		{
			echo "Speed: $MY_CURL_SPEED"
			echo "DNS: $MY_CURL_DNSTIME sec"
			echo "Total Time: $MY_CURL_TOTALTIME sec"
		} >> "$MY_OUTPUT"
		echo_code end
		
	else
		echo "Error"
	fi
}

echo_line
echo "Don't trust benchmark results you see,"
echo "      test out performance for yourself."
echo_line


#####################################################################
# Check the requirements
#
# These Ubuntu packages should be installed:
#  curl 
#  make
#  gcc
#  build-essential
#  net-tools
#  traceroute
#  perl
#  lshw 
#  ioping
#  fio
#  sysbench
#####################################################################

echo "> Check the Requirements"

check_if_root_or_die
check_operating_system
if [[ ! -d "$MY_DIR" ]]; then
	mkdir "$MY_DIR" || exit_with_failure "Could not create folder '$MY_DIR'"
fi
echo "<html>" > "$MY_OUTPUT" || exit_with_failure "Could not write to output file '$MY_OUTPUT'"
if ! command_exists curl; then
	exit_with_failure "'curl' is needed. Please install 'curl'. More details can be found at https://curl.haxx.se/"
fi
if ! command_exists make; then
	exit_with_failure "'make' is needed. Please install development tools (Ubuntu package 'build-essential') for your operating system."
fi
if ! command_exists gcc; then
	exit_with_failure "'gcc' is needed. Please install development tools (Ubuntu package 'build-essential') for your operating system."
fi
if ! command_exists perl; then
	exit_with_failure "'perl' is needed. Please install 'perl'. More details can be found at https://www.perl.org/get.html"
fi
if ! command_exists ifconfig; then
	exit_with_failure "'ifconfig' is needed. Please install network tools (Ubuntu package 'net-tools') for your operating system."
fi
if ! command_exists ping; then
	exit_with_failure "'ping' is needed. Please install network tools (Ubuntu package 'net-tools') for your operating system."
fi
if ! command_exists traceroute; then
	exit_with_failure "'traceroute' is needed. Please install 'traceroute'."
fi
if ! command_exists dd; then
	exit_with_failure "'dd' is needed. Please install 'dd'. More details can be found at https://www.gnu.org/software/coreutils/manual/"
fi
if ! command_exists lshw; then
	exit_with_failure "'lshw' is needed. Please install 'lshw'. More details can be found at http://www.ezix.org/project/wiki/HardwareLiSter"
fi
if ! command_exists ioping; then
	exit_with_failure "'ioping' is needed. Please install 'ioping'. More details can be found at https://github.com/koct9i/ioping"
fi
if ! command_exists fio; then
	exit_with_failure "'fio' is needed. Please install 'fio'. More details can be found at https://wiki.mikejung.biz/Benchmarking#Fio_Installation"
fi
if ! command_exists sysbench; then
	exit_with_failure "'sysbench' is needed. Please install 'sysbench'. More details can be found at https://github.com/akopytov/sysbench"
fi
if ! perl_module_exists "Time::HiRes"; then
	exit_with_failure "Perl module 'Time::HiRes' is needed. Please install 'Time::HiRes'. More details can be found at http://www.cpan.org/modules/INSTALL.html"
fi
if ! perl_module_exists "IO::Handle"; then
	exit_with_failure "Perl module 'IO::Handle' is needed. Please install 'IO::Handle'. More details can be found at http://www.cpan.org/modules/INSTALL.html"
fi
