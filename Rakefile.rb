require 'rake'

# Usage: blinds.rb [options]
#     -u, --username USERNAME          Your USERNAME
#     -p, --password PASSWORD          Your PASSWORD
#     -r, --room ROOM                  Set the ROOM number
#     -b, --blinds NUM                 Set the blinds to NUM
#     -c, --climate-control [CONTROL]  Set the climate control to [:ON, :OFF]
#     -m, --climate-mode [MODE]        Set the climate mode to [:HEAT, :COOL, :FAN_ONLY]
#     -f, --fan-speed SPEED            Set the fan speed to [25, 50, 75, 100]
#     -t, --temp TEMP                  Set the TEMPerature
#     -o, --open                       Open the door
#     -w, --window LIGHT               Set the window LIGHT
#     -d, --door LIGHT                 Set the door LIGHT
#     -l, --lights LIGHT               Set all the LIGHTS
#     -s, --state [OBJ]                See the actual OBJect control state
#     -v, --verbose
#     -a, --authors                    Show the authors list
#     -h, --help                       See this message

task :test, [:first_args] do |t, args|
  args.with_defaults(:first_args => "-h")
  ruby "./blinds.rb #{args.first_args}"
end

task :help do
  ruby "./blinds.rb -h"
end

task :open do
  ruby "./blinds.rb -o"
end

# TODO: in one
# task :climate_control, [:control] do |t, args|
#   args.with_defaults(:conrol => "ON")
#   ruby "./blinds.rb -c #{args.control}"
# end
task :climate_control_on do
  ruby "./blinds.rb -c ON"
end
task :climate_control_off do
  ruby "./blinds.rb -c OFF"
end

desc "Common task"
task :all => [ :help, :open, :climate_control_on, :climate_control_off ]
Rake::Task["all"].invoke

# task default: %w[test]
