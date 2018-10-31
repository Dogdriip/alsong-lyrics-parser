require_relative 'modules/alsong'

puts Alsong.get_lyrics ARGV[0], (ARGV[1] == nil ? " " : ARGV[1])