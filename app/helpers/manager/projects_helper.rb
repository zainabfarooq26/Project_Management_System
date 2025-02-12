module Manager::ProjectsHelper
    def assign_users_to_project(project, user_ids)
      user_ids = user_ids.reject(&:blank?) rescue []
      Rails.logger.debug "User IDs to assign: #{user_ids}"
  
      if user_ids.any?
        project.user_ids = user_ids
        return project.save
      end
      false
    end
  
    def user_checkboxes(form, users)
      form.collection_check_boxes(:user_ids, users, :id, lambda { |user| "#{user.first_name} #{user.last_name} (#{user.email})" }) do |cb|
        content_tag(:div, class: "form-check") do
          cb.check_box(class: "form-check-input") + cb.label(class: "form-check-label")
        end
      end
    end
  end
  