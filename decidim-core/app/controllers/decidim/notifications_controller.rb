# frozen_string_literal: true

module Decidim
  # The controller to handle the user's notifications deletion.
  class NotificationsController < Decidim::ApplicationController
    include HasSpecificBreadcrumb

    def index
      enforce_permission_to :read, :notification
    end

    def destroy
      notification = notifications.find(params[:id])
      enforce_permission_to(:destroy, :notification, notification:)
      notification.destroy
    end

    def read_all
      enforce_permission_to :destroy, :notification, notification: notifications.first
      notifications.destroy_all
    end

    private

    def notifications
      @notifications ||= current_user.notifications.order(created_at: :desc)
    end

    def breadcrumb_item
      {
        label: t("layouts.decidim.user_menu.notifications"),
        active: true,
        url: notifications_path
      }
    end
  end
end
