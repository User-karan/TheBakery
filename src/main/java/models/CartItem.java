package models;

public class CartItem {
    private int cartId;
    private int id; // userId
    private Product product;
    private int quantity;

    public CartItem(Product product, int quantity, int id) {
        this.product = product;
        this.quantity = quantity;
        this.id = id;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getId() {
        return id; // userId
    }

    public void setId(int id) {
        this.id = id;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalPrice() {
        return product != null ? product.getPrice() * quantity : 0;
    }

    public boolean isQuantityAvailable() {
        return product != null && product.getStockQuantity() >= quantity;
    }

    public int getProductId() {
        return product != null ? product.getProductId() : 0;
    }

    public double getUnitPrice() {
        return product != null ? product.getPrice() : 0.0;
    }
}
