# Little Esty Shop / Bulk Discounts Project

This is a RESTful application built on Rails to meet the requirements of the [Little Etsy Shop](https://github.com/turingschool-examples/little-esty-shop) group project and [Bulk Discounts](https://backend.turing.edu/module2/projects/bulk_discounts) solo project for Module 2 of the Back End Engineering program at [Turing School of Software and Software and Design](https://turing.edu/). The initial portion was completed by 2111 cohort members Mark Ertmer, Katy Harrod and Joseph Galvin. Mark completed the Bulk Discounts portion by building onto the exisiting repository. This project was completed in March of 2022.

[View the deployed application here](https://lil-esty-bulk-discounts.herokuapp.com/)

## Table of Contents

## Purpose and Functionality
The application is built to meet the needs of a hypothetical sales platform, wherin merchants can sell items to customers, view invoices, manage transactions and offer discounts. CRUD functionality is at the heart of this application, allowing both merchants and admin to create, read, update and delete a number of the resources based on different sets of available features.

## Database Structure & Interface
![image](https://user-images.githubusercontent.com/91342410/157998299-cc32d2fe-3436-47ab-ab12-26c99e0c6b85.png)

The involved resources consist of a many:many and several one:many relationships. PostgreSQL was the chosen database manager, and ActiveRecord was used for querying within Rails.

## Admin Capabilities
- Dashboard shows the top 5 customers based on number of successful transactions.
- Dashboard shows a list of all incompleted invoices, each with a link to that invoice's show page, sorted by oldest first
- Admin Merchants index shows the top 5 merchants based on total revenue earned, and that amount is listed along with the merchant's highest-earning day.
- Admin Merchants index shows lists of Active and Inactive merchants, with links to each merchant's show page.
- Each listing has a button to enable or disable the merchant, depending on its current status.
- Admins can create new merchants and update existing ones.

## Merchant Capabilities
- Admin Invoices index lists all invoices, along with the order status and a link to that invoice's show page.
- Admin Invoices show page lists customer info, lists the items ordered, and displays the order subtotalkljyhl;kjhl;kjh;kjh

## Bulk Discounts

## API Consumption
While the project focuses on CRUD functionality and advanced database querying, it did offer an opportunity to learn how to consume the [API]() in order to display the next 3 upcoming holidays on a merchant's Bulk Discounts page:
<img width="292" alt="image" src="https://user-images.githubusercontent.com/91342410/157999907-d629d22e-112c-4622-af62-313e291bffd2.png">

## Heroku Deployment

## Git Workflow

## Bootstrap

## Test-Driven Design

## CSV Data Loading


## Mark's Notes
- Deployed [here](https://lil-esty-bulk-discounts.herokuapp.com/)
- All required user stories have been completed.
- No extensions were attempted.
- I will be working on my AR/SQL chops!

## Background and Description

"Little Esty Shop" is a group project that requires students to build a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices.

## Learning Goals
- Practice designing a normalized database schema and defining model relationships
- Utilize advanced routing techniques including namespacing to organize and group like functionality together.
- Utilize advanced active record techniques to perform complex database queries
- Practice consuming a public API while utilizing POROs as a way to apply OOP principles to organize code

## Requirements
- must use Rails 5.2.x
- must use PostgreSQL
- all code must be tested via feature tests and model tests, respectively
- must use GitHub branching, team code reviews via GitHub comments, and github projects to track progress on user stories
- must include a thorough README to describe the project
- must deploy completed code to Heroku

## Setup

This project requires Ruby 2.7.4.

* Fork this repository
* Clone your fork
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rails db:create`
* Run the test suite with `bundle exec rspec`.
* Run your development server with `rails s` to see the app in action.

## Phases

1. [Database Setup](./doc/db_setup.md)
1. [User Stories](./doc/user_stories.md)
1. [Extensions](./doc/extensions.md)
1. [Evaluation](./doc/evaluation.md)
