property :name, String, name_property: true
property :variables, [String, Array], default: lazy { |r| r.name }

default_action :install

action :install do
    variables = [new_resource.variables].flatten.uniq
    for variable in variables do
        Chef::Log.warn("variable in :install block is: #{variable.to_s}")
        template "etc/#{variable.to_s}" do
            source 'test.erb'
            owner 'root'
            group 'root'
            mode '0755'
            variables ({ value: variable.to_s })
            not_if { who_is_running(variable) }
            action :create
        end

    end

end

action_class do
    def who_is_running(variable)
        Chef::Log.warn("variable in action_class is: #{variable.to_s}")
        variable == 4
    end
end
