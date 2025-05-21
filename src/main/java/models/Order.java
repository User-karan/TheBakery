package models;

import java.util.Date;

public class Order {
    private int orderId;
    private String email;
    private String productName;
    private int quantity;
    private Date orderDate;
    private double totalAmount;

    // Constructors
    public Order() {}

    public Order(int orderId, String email, String productName, int quantity, Date orderDate, double totalAmount) {
        this.orderId = orderId;
        this.email = email;
        this.productName = productName;
        this.quantity = quantity;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
    }

    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
}
