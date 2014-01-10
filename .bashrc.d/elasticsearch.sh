esget() {
    local path=$1; shift
    curl -XGET "http://localhost:9200/$path" "$@"
}

espost() {
    local path=$1; shift
    curl -XPOST "http://localhost:9200/$path" "$@"
}

esput() {
    local path=$1; shift
    curl -XPUT "http://localhost:9200/$path" "$@"
}

esdelete() {
    local path=$1; shift
    curl -XDELETE "http://localhost:9200/$path" "$@"
}

esplugins() {
    curl -s http://localhost:9200/_nodes?plugin=true | jq '.nodes[].plugins[].name'
}
