# Little "Esty" Shop / Bulk Discounts Project

This is a RESTful application built on Rails to meet the requirements of the [Little Esty Shop](https://github.com/turingschool-examples/little-esty-shop) group project and [Bulk Discounts](https://backend.turing.edu/module2/projects/bulk_discounts) solo project for Module 2 of the Back End Engineering program at [Turing School of Software and Software and Design](https://turing.edu/). The first part was completed by 2111 cohort members [Mark Ertmer](https://github.com/markertmer), [Katy Harrod](https://github.com/mcharrod) and [Joseph Galvin](https://github.com/jwgalvin). Mark completed the Bulk Discounts section by building onto the exisiting repository. The project was submitted 3/8/2022.

[VIEW THE DEPLOYED APPLICATION HERE](https://lil-esty-bulk-discounts.herokuapp.com/)

## Table of Contents
* [Purpose and Functionality](#purpose-and-functionality)
* [Database Structure and Interface](#database-structure-and-interface)
* [Admin Capabilities](#admin-capabilities)
* [Merchant Capabilities](#merchant-capabilities)
* [Bulk Discounts](#bulk-discounts)
* [API Consumption](#api-consumption)
* [Heroku Deployment and Git Workflow](#heroku-deployment-and-git-workflow)
* [Test-Driven Development](#test-driven-development)
* [CSV Data Loading](#csv-data-loading)
* [Data Validation and Sad Path Testing](#data-validation-and-sad-path-testing)

## Purpose and Functionality
The application is built to meet the needs of a hypothetical sales platform, wherin merchants can sell items to customers, view invoices, manage transactions and offer discounts. CRUD functionality is at the heart of this application, allowing both merchants and admin to create, read, update and delete a number of the resources based on different sets of available features. The learning goals of the project were given as follows:
- Practice designing a normalized database schema and defining model relationships
- Utilize advanced routing techniques including namespacing to organize and group like functionality together.
- Utilize advanced active record techniques to perform complex database queries
- Practice consuming a public API while utilizing POROs as a way to apply OOP principles to organize code

## Database Structure and Interface
![image](https://user-images.githubusercontent.com/91342410/157998299-cc32d2fe-3436-47ab-ab12-26c99e0c6b85.png)

The involved resources consist of a many:many and several nested one:many relationships. PostgreSQL was the chosen database manager, and ActiveRecord was used for querying within Rails.

## Admin Capabilities
- Dashboard
   <img width="500" alt="image" src="https://user-images.githubusercontent.com/91342410/158030863-0f4c5e65-1b11-4d9b-9f74-98563a3799c8.png">
   - See the top 5 customers based on number of successful transactions.
   - See a list of all incompleted invoices, each with a link to that invoice's show page, sorted by oldest first
- Merchants Index 
   - See the top 5 merchants based on total revenue earned, and that amount is listed along with the merchant's highest-earning day.
   - See lists of Active and Inactive merchants, with links to each merchant's show page.
   - Each listing has a button to enable or disable the merchant, depending on its current status.
- Invoices Index 
   - See all invoices, along with the order status and a link to that invoice's show page.
- Invoice Show
   - See the attributes for the invoice and each item ordered, and displays the order subtotal and final revenue with any applied discounts.
   - Update the invoice status with dropdown menu and button.
- Create new merchants and update existing ones.
   <img width="400" alt="edit-merchant-view" src="https://user-images.githubusercontent.com/91342410/158030899-9a1baf96-14fa-4937-b177-8448285c047e.png">


## Merchant Capabilities
- Dashboard
   - See the top 5 favorite customers based on number of successful transactions.
   - See all items that are ready to ship, with a link to the invoice they belong to.
   - Includes links to the merchant items index, merchant invoices index, and merchant bulk discounts index.
- Items Index 
   - See the top 5 selling items for that merchant based on revenue generated.
   - See all items that are disabled, all items that are enabled, along with a button that can change the status of each item.
- Items Show 
   - See the item's name, description and current price.
- Create new items and update exisiting ones.
- Invoices Index
   - See all invoices, along with the order status and a link to that invoice's show page.
- Invoice Show
   - See the attributes for the invoice and each item ordered, and displays the order subtotal and final revenue with any applied discounts.
   - Update each invoice item's status with dropdown menu and button.
   <img width="500" alt="image" src="https://user-images.githubusercontent.com/91342410/158030835-c9e776ee-71b1-4e41-890b-45ae4e271f28.png">


## Bulk Discounts
Additional functionality was added to give merchants the ability to offer quantity-based discounts on any of their items. The discount resource conists of a name, the percentage taken off the original price, and the quantity threshold that specifies how many of one item must be purchased for the discount to apply. In the case of multiple discounts applying, the application will choose the best deal for the customer by default.

- Bulk Discounts Index 
   <img width="400" alt="bulk-discounts-index" src="https://user-images.githubusercontent.com/91342410/158030967-c0cd1472-37c8-4676-9dea-8885b1490af9.png">
   - See all available discounts along with their percentage and threshold.
   - Delete discounts by clicking on a button.
   - See the next three upcoming holidays. [More info on this below]()
   - Includes links to each discount's show page
- Bulk Discounts Show
   - See all discount attributes.
- Create new discounts, and update and delete existing ones.
- Total discounted revenue is calculated and displayed on both the Admin and Merchant Invoice Show pages. 
- Applied discounts are also listed on the Merchant Invoice Show pages.

## API Consumption
While the project focuses on CRUD functionality and advanced database querying, it did offer an opportunity to learn how to consume the [Nager.Date API](https://date.nager.at/swagger/index.html) in order to display the next 3 upcoming holidays from the current date on a merchant's Bulk Discounts Index page:
<img width="292" alt="api-upcoming-holidays" src="https://user-images.githubusercontent.com/91342410/157999907-d629d22e-112c-4622-af62-313e291bffd2.png">

## Heroku Deployment and Git Workflow
The repository was connected to Heroku in such a way that any code merged into the `main` branch would be automatically deployed. This gave us the opportunity to practice staging our code on a separate branch, called `developer`, before moving it into production. This is the process we followed:

1. To update your machine, run `git fetch`. 
2. Switch into the `developer` branch.
3. From there, create a new branch `branchname` for your work
4. Make changes, `add` and `commit` to the branch
5. Make sure ALL tests are passing, check functionality on localhost:3000
6. Push `branchname` up to Github
7. Submit pull request to merge `branchname` into developer
   a. Teammate(s) review the branch & make comments/requests for changes (if any)
   b. Make the changes in your local `branchname` branch & re-push to Github
   c. On Github, reply to the comments in the pull request
   d. Teammate merges the pull request
8. Teammate(s) verify the updated developer branch
   a. Pull down changes
   b. Checkout developer
   c. All tests pass
   d. Everything working on localhost:3000
9. Merge into `main`
   a. Submit pull request to merge `developer` into `main`
   b. Teammate approves the PR & completes the merge
10. Check Heroku deployment and verify that everything is working correctly.

## Test-Driven Design
The project consists of 84 feature tests and 81 model tests, all passing with 100% coverage across the reop. Tests were written to the specifications of the [user stories](https://github.com/markertmer/little-esty-shop-bulk-discounts/blob/main/doc/user_stories.md) and used to direct the code production. To support thorough testing of features and models, several gems were incoroporated, including `rspec`, `capybara`, `launchy`, `shoulda-matchers`, `factory bot` and `faker`.

## CSV Data Loading
As this is a hypothetical application, there was a need to populate the database with sample data for customers, invoices, invoice items, items, merchants, transactions and discounts. These were provided in CSV files, which we were able to load after building a `rake` command using namespacing for each resource and a `csv_load:all` command for all data. This was done locally on each teammate's machine as well as on the Heroku app so that the data could be used on the live deployment. 
<img width="500" alt="csv-tasks" src="https://user-images.githubusercontent.com/91342410/158030747-2f66ad66-da74-4b8d-bba0-44d0948f4ee7.png">

## Data Validation and Sad Path Testing
While there is plenty of valid data in the development database for this project, it also needed measures to ensure that live users could not break anything by entering invalid data. Validations were incorporated across into each model where resources could be created or updated by a user, including the following conditions:
- Presence: resources cannot be created or updated with a blank form field.
- Numericality: strings cannot be entered when a number is expected.
- Integers: quantities must be given as whole numbers.
- Range: numbers must be positive, percents cannot be bigger than 100.
<img width="500" alt="model-validations" src="https://user-images.githubusercontent.com/91342410/158030775-525adc93-5995-4595-adb0-852a286eeb21.png">

When invalid data is entered, the user is redirected back to the same page, and a flash message highlights the specific error.

Additionally, several issues were avoided through the use of dropdown menus that only allow the user to enter a valid selection.
