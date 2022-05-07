function fish_title
    if [ $_ = 'fish' ]
        echo (basename $PWD)
    else
        echo $_
    end
end
