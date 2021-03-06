# Script to generate AutoCurry.swift file
# Modify the constant below if you need to curry a function with more than 10 arguments
MAX_AUTO_CURRY_ARG_COUNT = 10

def curry_generator(n)
  types = (1..n).map{|i| "T#{i}" }.join(", ")
  return_type = (1..n).map{|i| "T#{i}"}.join(" -> ")
  closures = (1..n).map{|i| "{ t#{i}"}.join(" in ")
  closing_braces = (1..n).map{ "}" }.join(" ")
  [
    "    public class func curry<#{types}, R>(f: (#{types}) -> R) -> #{return_type} -> R {",
    "        return #{closures} in f(#{types.downcase}) #{closing_braces}",
    "    }"
  ].join("\n")
end

funcs = [
  "// This is an autogenerated file. Do not edit this file manually.",
  "public extension $ {",
    (2..MAX_AUTO_CURRY_ARG_COUNT).map {|i| curry_generator(i) }.join("\n\n"),
  "}"
].join("\n\n")

File.open("#{File.dirname(__FILE__)}/Dollar/AutoCurry.swift", "w") do |file|
  file.write(funcs)
end
