#!/usr/bin/env ruby
require 'yaml'

yaml = YAML.load_file("test.yml")

yaml.each{ |cmd|
    subcmds = []
    cmd['subcmds'].each{ |subcmd|
        subcmds.push("#{subcmd['command']}:#{subcmd['description']}")
    }
    puts "compdef _#{cmd['name']} #{cmd['name']}"
    puts "_#{cmd['name']}(){"

    print "\tsubcmds=("
    print subcmds.join(' ')
    print ")\n"

    print "\t_arguments\\\n"
    print "\t\t'1:first arg:{_describe commands subcmds}'\n"

    puts "}"
}
