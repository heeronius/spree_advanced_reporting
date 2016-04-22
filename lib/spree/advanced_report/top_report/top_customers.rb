include ActionView::Helpers::NumberHelper
class Spree::AdvancedReport::TopReport::TopCustomers < Spree::AdvancedReport::TopReport
  def name
    "Top Customers"
  end

  def description
    "Top purchasing customers, calculated by revenue"
  end

  def initialize(params, limit)
    super(params)

    orders.each do |order|
      if order.user
        data[order.user.id] ||= {
          :email => order.user.email,
          :revenue => 0,
          :units => 0
        }
        data[order.user.id][:revenue] += revenue(order)
        data[order.user.id][:units] += units(order)
      end
    end

    self.ruportdata = Table(%w[email Units Revenue])
    data.inject({}) { |h, (k, v) | h[k] = v[:revenue]; h }.sort { |a, b| a[1] <=> b [1] }.reverse[0..limit].each do |k, v|
      revenue =  number_to_currency(data[k][:revenue], :unit => "VND", precision: 0, seperator: ".", format: "%n %u")
      ruportdata << { "email" => data[k][:email], "Units" => data[k][:units], "Revenue" =>revenue } 
    end 
   # ruportdata.replace_column("Revenue") { |r| "%0.0f VND" % r.Revenue }
   # ruportdata.rename_column("email", "Customer Email")
  end
end

#<%= number_to_currency(product.price, :unit => product.currency, precision: 0, seperator: ".", format: "%n %u") rescue '' %>