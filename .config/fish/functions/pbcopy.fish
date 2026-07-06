function pbcopy
    if isatty stdin
        if test (count $argv) -gt 0; and test -f $argv[1]
            cat $argv[1] | clip.exe
        else
            echo "Usage: pbcopy [file] or stdout | pbcopy"
        end
    else
        clip.exe
    end
end
