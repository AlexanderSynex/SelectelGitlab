runner = Ci::Runner.new(description: 'My Shared Runner', active: true, name: 'my-shared-runner', token: SecureRandom.hex(20), runner_type: Ci::Runner::runner_types["group_type"]);
runner.groups.append(User.last.groups.first);
runner.shell_executor_type!;
runner.save!;
runner_cred = {"#{runner.name}" => {"token" => "#{runner.token}"}};

reg_data = {"url"=>"Gitlab.config.gitlab.url", "token"=>"#{runner.token}"}
data = '#cloud-config
timezone: Europe/Moscow
write_files:
- path: "/opt/gomplate/values/user-values.yaml"
  permissions: "0644"
  content: |
'
data += "    gitlabURL: \"#{Gitlab.config.gitlab.url}\"\n"
data += "    token: \"#{runner.token}\"\n"

File.write("/tmp/runner-metadata.cfg", data);
File.write("/tmp/runner-creds.yaml", runner_cred.to_yaml);

exit;
