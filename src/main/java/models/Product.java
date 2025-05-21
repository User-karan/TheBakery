package models;


import java.sql.Timestamp;

public class Product {
    private int productId;
    private String productName;
    private String productDescription;
    private double price;
    private Timestamp entryDate; 
    private String category;
    private int stockQuantity;
    private String productImage;

    // Default constructor for database retrieval
    public Product() {}

    // Constructor for testing purposes
    public Product(int productId, String productName, String productDescription, double price, Timestamp entryDate, String category, int stockQuantity, String productImage) {
        this.productId = productId;
        this.productName = productName;
        this.productDescription = productDescription;
        this.price = price;
        this.entryDate = entryDate;
        this.category = category;
        this.stockQuantity = stockQuantity;
        this.productImage = productImage;
    }

    // Getters and Setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Timestamp getEntryDate() {
        return entryDate;
    }

    public void setEntryDate(Timestamp timestamp) {
        this.entryDate = timestamp;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }
}
