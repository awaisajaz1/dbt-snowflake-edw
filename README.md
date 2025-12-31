# 🏗️ dbt + Snowflake Data Warehouse Project

[![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](https://www.snowflake.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)

> A complete data warehouse implementation using dbt (data build tool) and Snowflake, featuring Bronze-Silver-Gold architecture for scalable analytics.

## 🎯 Project Overview

This project demonstrates modern data warehouse patterns using dbt and Snowflake, implementing the medallion architecture (Bronze → Silver → Gold) for data transformation and analytics.

### 🏛️ Architecture

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   BRONZE    │───▶│   SILVER    │───▶│    GOLD     │
│  (Raw Data) │    │ (Cleaned)   │    │ (Business)  │
└─────────────┘    └─────────────┘    └─────────────┘
```

- **Bronze Layer**: Raw data ingestion and storage
- **Silver Layer**: Data cleaning, validation, and standardization  
- **Gold Layer**: Business-ready analytics and dimensional models

## 📊 Sample Dataset

The project includes a comprehensive e-commerce dataset with:

| Table | Records | Description |
|-------|---------|-------------|
| `customers` | 10 | Customer information and profiles |
| `products` | 10 | Product catalog with categories and pricing |
| `orders` | 10 | Order transactions and status |
| `order_items` | 16 | Individual items within orders |
| `suppliers` | 10 | Supplier information and ratings |

## 🚀 Quick Start

### Prerequisites

- Python 3.8+
- Snowflake account
- Git
- VS Code (recommended)

### 1. Clone & Setup

```bash
git clone <repository-url>
cd dbt-snowflake-project
python -m venv venv
source venv/bin/activate  # On macOS/Linux
pip install -r requirements.txt
```

### 2. Configure dbt

```bash
# Copy template and customize
cp profiles_demo.yml ~/.dbt/profiles.yml
# Edit with your Snowflake credentials
nano ~/.dbt/profiles.yml
```

### 3. Setup Snowflake

```sql
-- Run in Snowflake worksheet
CREATE DATABASE DBT_DEMO;
CREATE WAREHOUSE DBT_WH WITH WAREHOUSE_SIZE = 'XSMALL';
USE DATABASE DBT_DEMO;
CREATE SCHEMA RAW;
CREATE SCHEMA STAGING; 
CREATE SCHEMA MARTS;
```

### 4. Load Sample Data

```bash
# Execute sample_data_setup.sql in Snowflake
# This creates tables with realistic e-commerce data
```

### 5. Run dbt

```bash
dbt debug  # Test connection
dbt run     # Build models
dbt test    # Run data tests
dbt docs generate && dbt docs serve  # View documentation
```

## 📁 Project Structure

```
dbt-snowflake-project/
├── 📄 README.md                          # This file
├── 📄 requirements.txt                   # Python dependencies
├── 📄 dbt_snowflake_setup_guide.md      # Detailed setup guide
├── 📄 sample_data_setup.sql             # Sample dataset
├── 📄 profiles_demo.yml                 # dbt profile template
├── 📄 .gitignore                        # Git ignore rules
└── dbtsnow/                             # dbt project
    ├── 📄 dbt_project.yml               # dbt configuration
    ├── models/                          # dbt models
    │   ├── staging/                     # Silver layer models
    │   ├── marts/                       # Gold layer models
    │   └── demo/                        # Demo models
    ├── macros/                          # Custom SQL macros
    ├── tests/                           # Data quality tests
    └── seeds/                           # Static data files
```

## 🛠️ Development Tools

### dbt Power User Extension

Enhance your development experience with the dbt Power User VS Code extension:

- 🔍 **SQL Compilation**: Preview compiled SQL
- 📊 **Lineage Graphs**: Visual model dependencies
- ⚡ **Auto-completion**: dbt functions and macros
- 🚀 **Integrated Commands**: Run dbt from VS Code

Install: Search "dbt Power User" in VS Code Extensions

### Recommended VS Code Extensions

- dbt Power User
- SQL Tools
- YAML
- GitLens

## 📈 Analytics Use Cases

This project enables analysis of:

- 👥 **Customer Analytics**: Lifetime value, segmentation, behavior
- 📦 **Product Performance**: Sales trends, category analysis
- 💰 **Revenue Metrics**: Monthly/quarterly sales, growth rates
- 🚚 **Order Analytics**: Fulfillment rates, shipping analysis
- 🏪 **Supplier Performance**: Rating analysis, delivery metrics

## 🧪 Data Quality & Testing

Built-in data quality checks:

- ✅ **Uniqueness tests**: Primary key validation
- ✅ **Not null tests**: Required field validation  
- ✅ **Referential integrity**: Foreign key relationships
- ✅ **Custom tests**: Business rule validation

```bash
dbt test  # Run all tests
dbt test --select staging  # Test specific layer
```

## 📚 Learning Resources

- 📖 [Complete Setup Guide](dbt_snowflake_setup_guide.md)
- 🎓 [dbt Documentation](https://docs.getdbt.com/)
- ❄️ [Snowflake Documentation](https://docs.snowflake.com/)
- 🏗️ [Medallion Architecture](https://www.databricks.com/glossary/medallion-architecture)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♂️ Support

- 📧 **Issues**: Open a GitHub issue
- 💬 **Discussions**: Use GitHub Discussions
- 📖 **Documentation**: Check the setup guide

---

<div align="center">

**Built with ❤️ using dbt and Snowflake**

[⭐ Star this repo](../../stargazers) • [🐛 Report Bug](../../issues) • [💡 Request Feature](../../issues)

</div>