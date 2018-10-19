<h1>BigBossEscapist</h1>
<h2>Introduction</h2>
<p>This script is for pretending that you're doing something worthwile with your time and avoid getting your PC to an idle status. It's more a proof of concept than anything else. Use at your own risk of getting fired. Intended for Linux machines (tested on Ubuntu).
</p>

<p>
The script used to move windows around is not my work, full credits to: ebattenberg/move-window

The stud.sh is just filler that I got from a random benchmark script: Cyclenerd/benchmark/blob/master/benchmark.sh
</p>

<h2>Required python modules</h2>
<p>All of them should be available using pip</p>
<ul>
  <li>pynput</li>
  <li>subprocess</li>
  <li>sys</li>
  <li>pdb</li>
  <li>json</li>
  <li>re</li>
  <li>os</li>
</ul>

<h2>Additional requirements</h2>
<ul>
  <li>dotool (sudo apt-get install xdotool)</li>
  <li>xwininfo (you probably have it already)</li>
</ul>

<h2>Installation and usage</h2>
<p>
To use it, you can place the whole directory wherever you want. The only required step is "installing" the move_window.py script: 
<p>

<ul>
  <li>Create a ".scripts" directory in your home folder.</li>  
  <li>Copy and paste the "move_window.py" script there.</li>
  <li>Run it with this: "python ~/.scripts/move_window.py autoconfig"</li>
</ul>

<p>
You should be ablo to run the "bbes.py" script now. Try it with "python /path/to/script/bbes.py".

If you want to run it using a shortcut, create a shortcut that runs the following command:
  <i>gnome-terminal -e 'bash -c "python /path/to/script/bbes.py"'</i>    
</p>
