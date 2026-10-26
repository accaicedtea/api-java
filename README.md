## How to run the app (Docker)

To run the full stack (Frontend, Backend, and Database) using Docker, follow these steps:

### Prerequisites
- Make sure you have **Docker** and **Docker Compose** installed on your machine. (We recommend [Docker Desktop](https://www.docker.com/products/docker-desktop/) for Windows and macOS).

### Starting the application
1. Clone the repository to your local machine.
2. Open a terminal and navigate to the root directory of the cloned repository (where the `docker-compose.yml` file is located).
3. Run the following command to build the images and start all the services in the background:
   ```bash
   docker compose up -d --build
    ```
4. Wait for the services to start. You can check the status of the containers by running:
    ```bash
    docker compose ps
     ```

To stop the application and remove the containers, run:
```bash
docker compose stop
```
