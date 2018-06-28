require 'vimrunner'
require 'vimrunner/rspec'
require_relative './support/vim'
require "vimbot"

PLUGIN_ROOT = File.expand_path("../..", __FILE__)
VIM_REPEAT_PATH = File.expand_path("spec/fixtures/repeat.vim", PLUGIN_ROOT)

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  plugin_path = File.expand_path('.')

  config.start_vim do
    vim = Vimrunner.start_gvim
    vim.add_plugin(plugin_path, 'plugin/linediff.vim')
    vim
  end

  c.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'

  config.include Support::Vim

  config.after :each do
    vim.command 'wall'
    vim.command 'tabnew'
    vim.command 'tabonly'
  end
end
