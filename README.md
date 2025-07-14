# Cypress Quickstart

This is a demo app for testing a CI/CD pipeline.

## Local Development

Use the set Node version.

`nvm use`

Install node packages.

`npm install`

`npm run start`

Open the app at http://localhost:3000/.

## Docker Image

Build the Docker image.

`docker build -t cypress-quickstart:latest .`

or specify the platform (i.e. Linux amd64)

`docker build --platform linux/amd64 -t cypress-quickstart:latest .`

Run the app in a Docker container.

`docker run -p 3000:3000 cypress-quickstart:latest`

Log in with your Docker Hub account.

`docker login -u [USERNAME]`

Tag the image with your Docker Hub username.

`docker tag cypress-quickstart:latest [USERNAME]/cypress-quickstart:latest`

Push Docker image to registry.

`docker push [USERNAME]/cypress-quickstart:latest`

## Testing

Open the Cypress GUI.

`npm run cy:open`

Run the tests in the terminal

`npm run cy:run`

## Contributors

[A5 Project](http://www.a5project.com/)
