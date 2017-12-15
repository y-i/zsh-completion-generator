#!/usr/bin/env ruby
require 'yaml'

def createCompilcatinWithDepth(cmd, names, num)
    subcmds = []
    cmd['subcmds'].each{ |subcmd|
        subcmds.push("#{subcmd['command']}:#{subcmd['description']}")
    }
    funcname = names.join('__')
    puts "_#{funcname}(){"

    print "\tsubcmds=("
    print subcmds.join(' ')
    print ")\n"

    print "\t_arguments\\\n"
    print "\t\t'#{num}:first arg:{_describe commands subcmds}' \\\n"
    print "\t\t'*: :->rests'\n"

    print "\tcase $state in\n"
    print "\t\trests)\n"
    print "\t\t\tif type _#{funcname}__${line[#{num}]} 1>/dev/null 2>/dev/null ; then\n"
    print "\t\t\t\t_#{funcname}__${line[#{num}]}\n"
    print "\t\t\tfi\n"
    print "\t\t;;\n"
    print "\tesac\n"

    puts "}"
    puts ''
    cmd['subcmds'].each{ |subcmd|
        if subcmd.key?('subcmds')
            names.push(subcmd['command'])
            createCompilcatinWithDepth(subcmd, names, num+1)
        end
    }
end

yaml = YAML.load_file("test.yml")

yaml.each{ |cmd|
    puts "compdef _#{cmd['name']} #{cmd['name']}"
    createCompilcatinWithDepth(cmd, [cmd['name']], 1)
}
