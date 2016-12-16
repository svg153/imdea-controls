imdea-controls
==============
<p align="left">
    <a href="https://travis-ci.org/svg153/imdea-controls">
        <img src="https://travis-ci.org/svg153/imdea-controls.svg?branch=dev"
             alt="Travis CI">
    </a>
</p>

A script to control the room blinds, temperature, lights and door at the IMDEA Software Institute.


Dependencies
------------

You do not worry about this, only run 'install.sh' script.

* Ruby 2.0.0 ONLY.
* Gems:
  * [Mechanize](http://mechanize.rubyforge.org/) gem.
    * This gem needed [Nokogiri](http://www.nokogiri.org/) gem.
  * [Rake](https://ruby.github.io/rake/) gem for testing.
*
* An office at the [IMDEA Software Institute](http://www.software.imdea.org) with an account.


Installation
------------
1. Clone the project.
```shell
$ git clone https://github.com/svg153/imdea-controls
```
1. Change to the folder.
```shell
$ cd imdea-controls
```
1. Give execute permission to `install.sh`.
```shell
$ chmod +x install.sh
```
1. Run install script. This will create an alias in `~ / .aliases` to run the script in any location, so there are two install ways. ONLY RUN ONE OF THEM:
  * 1º way - Normal: The blinds.rb alias will be "blinds".
  ```shell
  $ ./install.sh
  ```
  * 2º way - Custom: Give the alias by argument.
  ```shell
  $ ./install.sh -a'aliasForTheScriptBlinds'
  ```
1. Create the configuration file, `.blinds.yml`.
```shell
$ touch .blinds.yml
```
1. Copy this inside the `.blinds.yml` with your IMDEA Software information.
```yml
username: USERNAME
password: PASSWORD
room_no: ROOM
```
1. By deffault, `install.sh` saw you the help. But to see the help, type this.
```shell
$ ./blinds.rb -h
```

Usage
-----
```
$ ./blinds.rb -h
Usage: blinds.rb [options]
    -u, --username USERNAME          Your USERNAME
    -p, --password PASSWORD          Your PASSWORD
    -r, --room ROOM                  Set the ROOM number
    -b, --blinds NUM                 Set the blinds to NUM
    -c, --climate-control [CONTROL]  Set the climate control to [:ON, :OFF]
    -m, --climate-mode [MODE]        Set the climate mode to [:HEAT, :COOL, :FAN_ONLY]
    -f, --fan-speed SPEED            Set the fan speed to [25, 50, 75, 100]
    -t, --temp TEMP                  Set the TEMPerature
    -o, --open                       Open the door
    -w, --window LIGHT               Set the window LIGHT
    -d, --door LIGHT                 Set the door LIGHT
    -l, --lights LIGHT               Set all the LIGHTS
    -s, --state [OBJ]                See the actual OBJect control state
    -v, --verbose
    -a, --authors                    Show the authors list
    -h, --help                       See this message
```


Configuration file
------------------

`blinds.rb` looks for `.blinds.yml` in your home directory `~` and your current
directory `.`.  If `.blinds.yml` exists, `blinds.rb` will read your `USERNAME`,
`PASSWORD`, and `ROOM`.  `.blinds.yml` has the following format:

```yml
username: USERNAME
password: PASSWORD
room_no: ROOM
```

Authors
-------
* [Michael Emmi](https://github.com/michael-emmi)
* [Sergio Valverde](https://github.com/svg153)
