package dto;

public class Product {
	private int id;
    private String name;
    private String category;
    private double price;
    private String image;
    private String description;

    public Product(int prodId,String name, String category, double d, String description,String image) {
    	this.setId(prodId);
        this.name = name;
        this.category = category;
        this.price = d;
        this.image = image;
        this.description = description;
    }


	public Product() {
		// TODO Auto-generated constructor stub
	}


	public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}
}
