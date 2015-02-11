require 'simplecov-console'
require 'simplecov-summary'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[ SimpleCov::Formatter::SummaryFormatter,
                                                            SimpleCov::Formatter::Console]
SimpleCov.start

