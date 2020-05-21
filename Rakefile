task default: %w[generate]

task :generate do
	if command?('xcodegen')
		generate()
    else
    	install_xcodegen()
    	generate()
    end
end

task :set_marketing_number, :marketing_number do |t, args|
    marketing_number = args[:marketing_number]
    puts "Updating marketing number to #{marketing_number}..."
    `agvtool new-marketing-version #{marketing_number}`
end

task :set_build_number, :build_number do |t, args|
    build_number = args[:build_number]
    puts "Updating build number to #{build_number}..."
    `agvtool new-version #{build_number}`
end

task :test do
    if command?('xcpretty')
        test()
    else
        puts 'Installing xcpretty'
        `sudo gem install xcpretty`
        test()
    end
end

def command?(name)
    `which #{name}`
    $?.success?
end

def generate()
	puts 'Generating project...'
	`xcodegen`
end

def install_xcodegen()
	puts 'Installing xcodegen...'
	`brew install xcodegen`
end

def test()
    `set -o pipefail && xcodebuild test -scheme Knuckles -destination 'platform=iOS Simulator,name=iPhone 11,OS=13.4.1' | xcpretty`
end
