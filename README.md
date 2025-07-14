# Cypress Quickstart

This is a demo app for testing a CI/CD pipeline.

The app shall be accessible at http://localhost:3000/.

## Build a Docker image.

`docker build -t cypress-quickstart .`

## Run the app in a Docker container.

`docker run -p 3000:3000 cypress-quickstart`

## Test the app with Cypress.

`npm run cy:open`
