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
    print "\t\t\t_#{funcname}__${line[#{num}]}\n"
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
    print "\t\t'1:first arg:{_describe commands subcmds}' \\\n"
    print "\t\t'*: :->rests'\n"

    print "\tcase $state in\n"
    print "\t\trests)\n"
    print "\t\t\t_#{cmd['name']}__${line[1]}\n"
    print "\t\t;;\n"
    print "\tesac\n"

    puts "}"
    puts ''
    cmd['subcmds'].each{ |subcmd|
        if subcmd.key?('subcmds')
            names = [cmd['name']]
            names.push(subcmd['command'])
            createCompilcatinWithDepth(subcmd, names, 2)
        end
    }
}

