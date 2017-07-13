require 'jsonlint'
jsoncheck = JsonLint::Linter.new()
jsoncheck.check(ARGV[0])
jsoncheck.display_errors
# jsoncheck.display_errors.each { |e| 
  # puts "Results: #{e}"
# }

