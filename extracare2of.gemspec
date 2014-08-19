# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'extracare2of/version'

Gem::Specification.new do |spec|
  spec.name          = "extracare2of"
  spec.version       = ExtraCare2OF::VERSION
  spec.authors       = ["Nick Prokesch"]
  spec.email         = ["nick@prokes.ch"]
  spec.summary       = %q{send CVS ExtraCare coupon reminders to OmniFocus}
  spec.description   = %q{Logs into CVS account, adds coupons with due dates to OmniFocus, remembers imported coupons}
  spec.homepage      = "https://github.com/prokizzle/extracare2of"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths    = ["lib"]
  spec.bindir = 'bin'
  spec.executables << 'extracare2of'

  spec.add_dependency "mechanize", "~> 2.7"
  spec.add_dependency "amatch", "~> 0.2"
  spec.add_dependency "rb-appscript", "~> 0.6"
  spec.add_dependency "highline", "~> 1.6"
  spec.add_dependency "chronic", "~> 0.10"
  spec.add_dependency "sqlite3", "~> 1.3"
end