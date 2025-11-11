import data.ConnectionDB;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {
        ConnectionDB connectionDB = new ConnectionDB();
        connectionDB.openConnection();
        connectionDB.closeConnection();
    }
}