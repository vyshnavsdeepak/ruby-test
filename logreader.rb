class LogReader
    def initialize(filePath)
        @views_count_hash = {}
        @unique_visit_hash = {}
        File.foreach(filePath) {
            | line | 
            line_split = line.split
            url = line_split[0]
            ip = line_split[1]
            saveLine(url, ip)
        }
    end

    def saveLine(url, ip)
        @views_count_hash[url] = (@views_count_hash[url] || 0) + 1

        @unique_visit_hash[url] = (@unique_visit_hash[url] || {})
        @unique_visit_hash[url][ip] = 0 # just some placeholder
    end

    def getUniqueVisit()
        return @unique_visit_hash
    end

    def getUniqueVisitsCount()
        return @unique_visit_hash.map { |url, ips| [url,ips.length()] }.to_h
    end

    def getViewsCount()
        return @views_count_hash
    end
end

def sortHashByValue(hash)
    return hash.sort_by {|_key, value| value}.reverse
end

def printMap (map, title)
    puts "\n" + title
    map.each do |key, value|
        puts key +  " : " + value.to_s
    end
end


def main()
    fileName = ARGV[0]
    log = LogReader.new(fileName)

    views = log.getViewsCount()
    unique_views = log.getUniqueVisitsCountSorted()
    printMap(sortHashByValue(views), "Views")
    printMap(sortHashByValue(unique_views), "Unique Visits")
end

if __FILE__ == $0
    main()
end