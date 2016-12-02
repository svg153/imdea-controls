imdea-controls
==============

A script to control the room temperature, blinds, and lights at the IMDEA Software Institute.


Dependencies
------------

You do not worry about this, only run 'install.sh' script.

* Ruby 2.0.0 ONLY.
* The Ruby [Mechanize](http://mechanize.rubyforge.org/) gem.
  * This gem needed [Nokogiri](http://www.nokogiri.org/) gem.
* An office at the [IMDEA Software Institute](http://www.software.imdea.org) with an account.


Installation
------------
1. Clone the project.
```shell
$ git clone https://github.com/svg153/imdea-controls
```
2. Change to the folder.
```shell
$ cd imdea-controls
```
3. Give execute permission to `install.sh`.
```shell
$ chmod +x install.sh
```
4. run install script.
```shell
$ ./install.sh
```
5. Create the configuration file, `.blinds.yml`.
```shell
$ touch .blinds.yml
```
6. Copy this inside the `.blinds.yml` with your IMDEA Software information.
```yml
username: USERNAME
password: PASSWORD
room_no: ROOM
```
7. By deffault, `install.sh` saw you the help. But to see the help, type this.
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
