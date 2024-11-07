# RFM-Analysis-on-E-Commerce-Data
RFM Analysis with E-Commerce Data Using PostgreSQL Resources

# RFM Analysis on E-Commerce Data

This project showcases an RFM (Recency, Frequency, Monetary) analysis performed on an e-commerce dataset to segment customers based on their purchasing behavior. By leveraging SQL queries, the analysis calculates RFM scores and segments customers into categories commonly used in customer relationship management (CRM). This segmentation enables businesses to design targeted marketing campaigns, improve customer retention, and drive revenue growth.

## Dataset

The dataset used for this analysis is available on Kaggle and includes comprehensive information about e-commerce transactions, such as customer IDs, invoice dates, invoice numbers, item quantities, unit prices, and more. This dataset provides an excellent foundation for analyzing customer behavior and performing RFM segmentation.

You can access and download the dataset from the following link:

[E-Commerce Dataset on Kaggle](https://www.kaggle.com/datasets/carrie1/ecommerce-data)

## RFM Analysis

RFM analysis is a data-driven method to segment customers based on their purchasing history. The three components of RFM are:

- **Recency (R)**: How recently a customer made a purchase.
- **Frequency (F)**: How often a customer makes purchases.
- **Monetary (M)**: How much a customer spends in total.

Each component is scored on a scale of 1 to 5, and the combination of these scores gives an overall RFM score for each customer.

### SQL Query for RFM Scoring

The RFM scores are generated through SQL queries as follows:

- **Recency Calculation**: Days since the last purchase relative to a reference date (2011-12-09).
- **Frequency Calculation**: Number of distinct purchases made by each customer.
- **Monetary Calculation**: Total amount spent by each customer.

The query segments customers by:
- Using NTILE(5) for recency and monetary scores.
- Applying a CASE WHEN statement for frequency to handle skewed distributions (e.g., customers with a single purchase).

### Customer Segmentation

Based on the RFM scores, customers are segmented into categories widely recognized in the CRM field, each representing distinct customer behaviors. Below are the segment definitions:

- **Champions**: Highest engagement and spending, frequent recent purchases.
- **Loyal Customers**: Regularly engaged customers with steady spending habits.
- **Potential Loyalists**: Recently acquired customers who show promise of loyalty.
- **New Customers**: Recently acquired customers with low frequency.
- **Promising**: Engaged customers with moderate recent activity.
- **Need Attention**: Customers who haven't engaged as actively but may return.
- **About to Sleep**: Customers with low recent engagement, potential to churn.
- **At Risk**: Previously active customers who have recently disengaged.
- **Hibernating**: Customers with very low engagement and spending, likely inactive.
- **Can’t Lose**: Valuable customers who may be on the verge of disengagement.

## RFM Segment Distribution

The chart below illustrates the distribution of customers across different RFM segments based on their purchasing behavior.

![RFM Segment Chart](https://github.com/eatasal/RFM-Analysis-on-E-Commerce-Data/blob/main/RFM_Chart.png)

### Analysis Insights

- **Hibernating**: The largest segment, suggesting many customers have become inactive. This group represents a re-engagement opportunity, perhaps through targeted campaigns or special offers to encourage them to return.
- **At Risk**: The second largest segment, consisting of customers who were previously active but are now disengaging. Retention efforts, like personalized offers or loyalty perks, can help win back these customers.
- **Loyal Customers**: A core group of regularly engaged customers, indicative of the company’s customer retention potential. This group could be nurtured further through loyalty programs or exclusive rewards.

## Strategic Recommendations

- **Reactivation Campaigns**: Develop tailored marketing strategies to engage customers in the Hibernating and At Risk segments, as they represent the largest groups.
- **Loyalty Enhancement**: Focus on rewarding and retaining Loyal Customers to ensure sustained growth and customer satisfaction.
- **Potential Loyalists and New Customers**: Engage these segments with onboarding programs and personalized communications to foster long-term loyalty.

## Tools and Libraries

- **SQL**: The primary language used to calculate RFM scores and segment customers.

## Getting Started

To reproduce the analysis, follow these steps:

1. Download the dataset from Kaggle ([E-Commerce Dataset on Kaggle](https://www.kaggle.com/datasets/carrie1/ecommerce-data)).
2. Run the SQL scripts or Jupyter Notebook provided in this repository to perform the RFM analysis, customer segmentation, and data visualization.

## Contact

For any questions or further information, feel free to reach out via email or connect on [LinkedIn](linkedin.com/in/elifatasal). 
