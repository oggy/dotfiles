viewtex() {
    if [ $# -gt 1 ]; then
        echo "USAGE: $0 PATH" >&2
        return 1
    fi

    local file
    if [ $# -eq 0 ]; then
        local num_matches=`ls -1 *.tex 2> /dev/null | wc -l`
        if [ "$num_matches" -eq 0 ]; then
            echo "No .tex file here." >&2
            return 1
        elif [ "$num_matches" -eq 1 ]; then
            file=$(ls -1 *.tex)
        else
            echo "Multiple .tex files here:" >&2
            ls -l *.tex
            return 1
        fi
    else
        file=$1; shift
    fi
    pdflatex "$file" && open "${file%.tex}.pdf"
}
