@RestController
public class KeepAliveController {
    @GetMapping("/keep-alive")
    public String keepAlive() {
        return "Servidor activo";
    }
}