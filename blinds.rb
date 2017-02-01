#!/usr/bin/env ruby
#!/usr/bin/ruby
#!/usr/local/bin/ruby

require 'rubygems'
require 'mechanize'
require 'optparse'
require 'yaml'

$loud = false

AUTHORS = ["@michael-emmi", "@svg153"]

def getAuthors
  str = "Authors: "
  AUTHORS.each_with_index do |author, index|
    str += author
    (index == AUTHORS.size - 1) ? str += "." : str += ", "
  end
  return str
end


class Controls
  #URI_OLD = 'http://control.imdeasoftware.org/screenmate/ScreenMateChangeValuePage.aspx'
  URI = 'https://software.imdea.org/intranet/control/'

  IDS = {
    open_door: 'open_door',
    door_light: 'door_light',
    window_light: 'window_light',
    blind: 'blind',
    climate_mode: 'climate_mode',
    climate_control: 'climate_control',
    fan_speed: 'fan_speed',
    temp: 'temp'
  }

  IDStoCHECK = {
    open_door: 'door_is_closed',
    door_light: 'door_light',
    door_light_control: 'door_light_control',
    window_light: 'window_light',
    window_light_control: 'window_light_control',
    blind: 'blind',
    climate_mode: 'climate_mode',
    climate_control: 'climate_control',
    fan_speed: 'fanspeed',
    temp: 'temp'
  }

  IDStoCHECKExceptions = {
    temp: 'temp_set',
    open_door: 'window_is_closed'
  }

  DEFAULTS = {
    door_light: 'OFF',
    window_light: 'AUTO',
    blind: '10',
    climate_mode: 'FAN_ONLY',
    climate_control: 'OFF',
    fan_speed: '100',
    temp: '25'
  }

  def select_option(form, field_id, text)
    value = nil
    form.field_with(:id => field_id).options.each{|o| value = o if o.text == text }

    raise ArgumentError, "No option with text '#{text}' in field '#{field_id}'" unless value
    form.field_with(:id => field_id).value = value
  end

  def initialize(username, password, room)
    @agent = Mechanize.new
    @username = username
    @password = password
    @room = room

    # begin the session
    print "opening session... " if $loud
    home = @agent.get(URI)
    title = home.title()
    form = home.form
    puts "OK" if $loud && form
    abort "Could not open session." unless form

    # login
    form.user = @username
    form.pass = @password

    print "logging in #{title}... " if $loud
    button = form.button_with(:value => "Log in")
    page = @agent.submit(form, button)
    puts "OK" if $loud && page
    abort "could not log in as #{@username}." unless page

  end

  private

  def set_control_uri
    URI+"set/"
  end

  def control(obj, val)
    print "setting controls... " if $loud
    obj_control_set_uri = "#{set_control_uri}" + "#{@room}/#{obj}/#{val}"
    page = @agent.get(obj_control_set_uri)
    puts "OK" if $loud && page
    abort "control command failed." unless page
    nil
  end

  def get_json_control_state(room)
    room_control_get_uri = URI+"get/" + "#{room}"
    json = @agent.get(room_control_get_uri).body
    return json
  end

  def get_control_state(room)
    result = JSON.parse(get_json_control_state(room))
    return result
  end

  def check_control(obj, val)
    res = 0
    result = get_control_state(@room)
    obj_get = IDStoCHECK[:"#{obj}"]
    obj_get_control = IDStoCHECK[:"#{obj}_control"]
    val_get = result['data'][obj_get]
    val_get_control = result['data'][obj_get_control]

    # resArray = get_obj_control_state(result, obj);
    # val_get = resArray[1][0]
    # val_get_control = resArray[1][1]

    # print "val=#{val}"; print "\n"
    # print "val_get=#{val_get}"; print "\n"
    # print "val_get_control=#{val_get_control}"; print "\n"

    res = 1 if "#{val}" == "#{val_get}" || "#{val}" == "#{val_get_control}"
    return res
  end

  def str_control_state(obj)
    str = "\ncontrol : actual state\n"
    str += "------------------------\n"
    json = get_control_state(@room)
    exceptions = ["ALL"]
    IDStoCHECK.each do |objId, objGET|
      if exceptions.include?("#{obj}") || "#{obj}"=="#{objId}"
        val = json['data']["#{objGET}"]
        str += "#{objId} : #{val} \n"
        IDStoCHECKExceptions.each do |objIdE, objGETE|
          if "#{objId}"=="#{objIdE}"
            val = json['data']["#{objGETE}"]
            str += "#{objGETE} : #{val} \n"
          end
        end
      end
    end
    return str
  end


  public

  def self.cmdline(args)
    username = nil
    password = nil
    room = nil
    blinds = nil
    control, mode, fanSpeed, temp = nil
    window, door = nil
    objectState = nil

    cfg = {}
    ['.', Dir.home, Dir.pwd, File.dirname(__FILE__)].each do |path|
      cfgfile = File.join(path, '.blinds.yml')
      if File.exists? cfgfile then
        puts "loading configuration file #{cfgfile}"
        cfg = YAML::load_file(cfgfile)
        break
      end
    end

    OptionParser.new do |opts|
      opts.banner = "Usage: #{File.basename $0} [options]"
      opts.on("-u", "--username USERNAME", "Your USERNAME") do |n|
        username = n
      end
      opts.on("-p", "--password PASSWORD", "Your PASSWORD") do |n|
        password = n
      end
      opts.on("-r", "--room ROOM", Integer, "Set the ROOM number") do |n|
        room = n
      end
      opts.on("-b", "--blinds NUM", Integer, "Set the blinds to NUM") do |n|
        blinds = n
      end

      controlOPS = [:ON, :OFF]
      opts.on("-c", "--climate-control [CONTROL]", controlOPS, "Set the climate control to #{controlOPS}") do |n|
        control = n if n
        abort "Only can set the climate control to #{controlOPS} options" unless n
      end

      modeOPS = [:HEAT, :COOL, :FAN_ONLY]
      opts.on("-m", "--climate-mode [MODE]", modeOPS, "Set the climate mode to #{modeOPS}") do |n|
        mode = n if n
        abort "Only can set the climate mode to #{modeOPS} options" unless n
      end

      fanSpeedOPS = [25, 50, 75, 100]
      opts.on("-f", "--fan-speed SPEED", fanSpeedOPS, "Set the fan speed to #{fanSpeedOPS}") do |n|
        fanSpeed = n
      end

      opts.on("-t", "--temp TEMP", Float, "Set the TEMPerature") do |n|
        temp = n
      end
      lightsOPS = [Integer, :OFF, :AUTO]
      opts.on("-w", "--window LIGHT", lightsOPS, "Set the window LIGHT") do |n|
        window = n
      end
      opts.on("-d", "--door LIGHT", lightsOPS, "Set the door LIGHT") do |n|
        door = n
      end
      opts.on("-l", "--lights LIGHT", lightsOPS, "Set all the LIGHTS") do |n|
        window = n
        door = n
      end
      objects = IDS
      opts.on("-s", "--state [OBJ]", objects, "See the actual OBJect control state") do |n|
        objectState = n ? n : "ALL"
      end
      opts.on("-v", "--verbose") do |v|
        $loud = v
      end
      opts.on("-a", "--authors", "Show the authors list") do
        puts getAuthors
      end
      opts.on("-h", "--help", "See this message") do
        puts opts
      end
      # not run
      # rescue OptionParser::InvalidOption => e
      #   puts e
      #   puts opts
      #   exit(1)
    end.parse!(args)

    username ||= cfg['username']
    password ||= cfg['password']
    room ||= cfg['room_no'].to_i

    abort("Must specify a username.") unless username
    abort("Must specify a password.") unless password
    abort("Must specify a room number.") unless room

    c = Controls.new(username, password, room) if blinds || mode || control || fanSpeed || temp || window || door || objectState
    c.door_light(door) if door
    c.window_light(window) if window
    c.blind(blinds) if blinds
    c.climate_mode(mode) if mode
    c.climate_control(control) if control
    c.fan_speed(fanSpeed) if fanSpeed
    c.temp(temp) if temp
    c.state(objectState) if objectState


  end


  def state(obj)
    str = str_control_state(obj)
    puts str
  end


  options = [:open_door, :door_light, :window_light, :blind, :climate_mode, :climate_control, :fan_speed, :temp]
  options.each do |x|
    define_method(x) do |val|
      val ||= DEFAULTS[x]
      obj = IDS[:"#{x}"]
      print "#{x.to_s.gsub(/_/,' ')} setting to #{val}... "
      control(obj, val)
      sleep(1)
      done = check_control(obj, val)
      puts done==1 ? "OK" : "ERROR"
    end
  end
end

Controls.cmdline(ARGV) if __FILE__ == $0
