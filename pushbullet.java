import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Objects;

public class Pushbullet {

  private static final String DEFAULT_CONFIG_FILE = "~/.pushbullet";
  private static final String PUSHBULLET_API_URL = "https://api.pushbullet.pushbullet.com/v2/pushes";

  private String configFile;
  private String pushbulletToken;

  public Pushbullet() {
    this.configFile = DEFAULT_CONFIG_FILE;
  }

  public Pushbullet(String configFile) {
    this.configFile = configFile;
  }

  public void setConfigFile(String configFile) {
    this.configFile = configFile;
  }

  public void readToken() throws IOException {
    if (new java.io.File(configFile).isFile()) {
      try (BufferedReader reader = new BufferedReader(new FileReader(configFile))) {
        String line;
        while ((line = reader.readLine()) != null) {
          if (line.startsWith("PUSHBULLET_TOKEN=")) {
            pushbulletToken = line.substring(18);
            return;
          }
        }
      }
    }
    throw new RuntimeException("Error: PUSHBULLET_TOKEN not found in configuration file (" + configFile + ").");
  }

  public void sendNotification(String title, String body) throws IOException, InterruptedException {
    Objects.requireNonNull(title, "Title cannot be null");
    Objects.requireNonNull(body, "Body cannot be null");

    String json = "{\"body\":\"" + body + "\", \"title\":\"" + title + "\"}";
    HttpRequest request = HttpRequest.newBuilder()
        .POST(HttpRequest.BodyPublishers.ofString(json))
        .uri(java.net.URI.create(PUSHBULLET_API_URL))
        .header("Authorization", "Bearer " + pushbulletToken)
        .header("Content-Type", "application/json")
        .build();

    HttpClient client = HttpClient.newHttpClient();
    HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

    int statusCode = response.statusCode();
    if (statusCode == 200) {
      System.out.println("Pushbullet notification sent!");
    } else {
      switch (statusCode) {
        case 429:
          System.out.println("Error: Pushbullet rate limit exceeded.");
          break;
        case 401:
          System.out.println("Error: Invalid Pushbullet API token.");
          break;
        default:
          System.out.println("Error: Pushbullet notification failed (code: " + statusCode + ")");
      }
    }
  }

  public static void main(String[] args) throws IOException, InterruptedException {
    Pushbullet pushbullet = new Pushbullet();

    // Parse arguments
    String title = args.length > 0 ? args[0] : "Default Title";
    String body = args.length > 1 ? args[1] : "Default Body";

    // Validate title
    if (title.isEmpty() || !title.matches("[\\w\\s]+")) {
      System.out.println("Error: Invalid title provided.");
      System.exit(1);
    }

    // Read token from config file
    pushbullet.readToken();

    // Send notification
    pushbullet.sendNotification(title, body);
  }
}
