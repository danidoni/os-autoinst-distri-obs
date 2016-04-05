use base "basetest";
use strict;
use testapi;

sub run() {
	assert_script_run("git clone --single-branch --branch rspec_appliance_tests_fix --depth 1 https://github.com/shyukri/open-build-service.git  /tmp/open-build-service", 200);
	assert_script_run("cd /tmp/open-build-service/dist/t"); # we don't need bundle install in the appliance!
	assert_script_run("set -o pipefail; rspec --format documentation | tee /tmp/rspec_tests.txt", 360);
	save_screenshot;
	}

sub test_flags() {
	return {important => 1};
	}

sub post_fail_hook {
	upload_logs("/tmp/rspec_tests.txt");
	assert_script_run("tar -cvf /tmp/capybara_screens.tar.gz /tmp/rspec_screens/*");
	upload_logs("/tmp/capybara_screens.tar.gz");
	assert_script_run("tar -cvf /tmp/srv_www_obs_api_logs.tar.gz /srv/www/obs/api/log/*");
	upload_logs("/tmp/srv_www_obs_api_logs.tar.gz");
	assert_script_run("tar -cvf /tmp/build_home_Admin.tar.gz /srv/obs/build/*");
	upload_logs("/tmp/build_home_Admin.tar.gz");
	}
1;