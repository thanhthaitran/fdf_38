module Admin
  class OrdersController < AdminBaseController
    before_action :find_order, only: :update

    def index
      @orders = Order.all.created_at_desc.paginate page: params[:page],
        per_page: Settings.admin.orders.number_of_orders
    end

    def update
      status = params[:status].to_i
      if (check_status status) && (@order.update_attribute :status, status)
        Admin::OrderMailer.admin_respon(@order.user, @order).deliver_now
        flash[:success] = t ".update_success"
      else
        flash[:danger] = t ".update_failed"
      end
      redirect_to admin_orders_path
    end

    private

    def find_order
      @order = Order.find_by id: params[:id]
      return if @order
      flash[:danger] = t "admin.orders.not_found_order"
      redirect_to admin_orders_path
    end

    def check_status status
      array = [Settings.orders.accept_status, Settings.orders.reject_status]
      true if array.include? status
    end
  end
end