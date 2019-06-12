package domain;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;


public class Connect2DB {

    public static  Connection connect2DB(){

        Connection con = null;
        try
        {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            String url = "jdbc:sqlserver://localhost:1433;\\SQLDEVELOPER;databaseName=DBLAB;user=Kosar;password=12345";
            con = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-V53PIN7\\SQLDEVELOPER;databaseName=DBLAB","Kosar","12345");

            /*Statement s1 = con.createStatement();
            ResultSet rs = s1.executeQuery("SELECT dbo.farmCount(0);");


            String[] result = new String[20];
            int ColCount = 2;
            if(rs!=null){
                int i =0;
                while(rs.next()) {
                    System.out.println(rs.getInt(1));
                    i++;
                }
            }*/

        } catch (Exception e)
        {
            System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            System.exit(0);
        }

        System.out.println("Opened database successfully");
        return con;
    }

    public static ArrayList< ArrayList<Integer> > getClansInfo(){
        Connection con = connect2DB();
        ArrayList< ArrayList<Integer> > res = new ArrayList< ArrayList<Integer> > ();


        CallableStatement cs = null;

        try {

            cs = con.prepareCall("{call getClanIds()}");

            ResultSet rs = cs.executeQuery();

            int i =0;
            while(rs.next()){
                ArrayList<Integer> tmp = new ArrayList<Integer>();
                int ind = 0;
                int clanId = rs.getInt(1);

                tmp.add(clanId);

                cs = con.prepareCall("{call ScoreBoard(?)}");
                cs.setInt(++ind,clanId);
                ResultSet rs1 = cs.executeQuery();

                while(rs1.next()){
                    tmp.add(rs1.getInt(1));
                    tmp.add(rs1.getInt(2));
                    tmp.add(rs1.getInt(3));
                }


                cs = con.prepareCall("{? = call getGold(?)}");
                ind = 0;
                cs.registerOutParameter(++ind, Types.INTEGER);
                cs.setInt(++ind,clanId);
                cs.execute();
                tmp.add(cs.getInt(1));

                cs = con.prepareCall("{? = call getLumber(?)}");
                ind = 0;
                cs.registerOutParameter(++ind, Types.INTEGER);
                cs.setInt(++ind,clanId);
                cs.execute();
                tmp.add(cs.getInt(1));

                cs = con.prepareCall("{? = call getFood(?)}");
                ind = 0;
                cs.registerOutParameter(++ind, Types.INTEGER);
                cs.setInt(++ind,clanId);
                cs.execute();
                tmp.add(cs.getInt(1));

                cs = con.prepareCall("{? = call getArmy(?)}");
                ind = 0;
                cs.registerOutParameter(++ind, Types.INTEGER);
                cs.setInt(++ind,clanId);
                cs.execute();
                tmp.add(cs.getInt(1));

                res.add(tmp);

            }

        }catch(Exception e){
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }


        return res;
    }

    public static int getClanLevel(int clanId){
        Connection con = connect2DB();
        CallableStatement cs = null;

        int ind = 0;
        try {
            cs = con.prepareCall("{? = call getClanLevel(?)}");
            ind = 0;
            cs.registerOutParameter(++ind, Types.INTEGER);
            cs.setInt(++ind, clanId);
            cs.execute();
            return cs.getInt(1);

        }catch(Exception e) {
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }
        return 0;
    }

    public static String getClanChant(int clanId){
        Connection con = connect2DB();
        CallableStatement cs = null;
        String chant = "";

        int ind = 0;
        try {
            cs = con.prepareCall("{call getChant(?)}");
            ind = 0;
            cs.setInt(++ind, clanId);
            ResultSet rs = cs.executeQuery();
            while(rs.next())
                chant = rs.getString(1);


        }catch(Exception e) {
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }
        return chant;
    }

    public static boolean isAdmin(String user){
        Connection con = connect2DB();
        CallableStatement cs = null;
        int ind = 0;

        boolean admin = false;

        try {
            cs = con.prepareCall("{? = call getRoleId(?)}");
            ind = 0;
            cs.registerOutParameter(++ind,Types.INTEGER);
            cs.setString(++ind, user);
            cs.execute();
            admin = (cs.getInt(1) == 3);

        }catch(Exception e) {
            System.out.println(  e.getClass().getName() + ": " + e.getMessage() );
        }
        return admin;

    }

    public static int getRole(String user){
        Connection con = connect2DB();
        CallableStatement cs = null;
        int ind = 0;

        int role = 0;

        try {
            cs = con.prepareCall("{? = call getRoleId(?)}");
            ind = 0;
            cs.registerOutParameter(++ind,Types.INTEGER);
            cs.setString(++ind, user);
            cs.execute();
            role = cs.getInt(1);

        }catch(Exception e) {
            System.out.println(  e.getClass().getName() + ": " + e.getMessage() );
        }
        return role;

    }

    public static ArrayList<ArrayList<Integer> > sort(ArrayList<ArrayList<Integer> > L){
        for(int i=0;i < L.size();i++){
            for(int j=i + 1;j < L.size();j++){
                if(L.get(j).get(1) > L.get(i).get(1) ||
                        (L.get(j).get(1) == L.get(i).get(1) && L.get(j).get(2) > L.get(i).get(2)) ||
                (L.get(j).get(1) ==  L.get(i).get(1) && L.get(j).get(2) == L.get(i).get(2) && L.get(j).get(3) < L.get(i).get(3)) ){
                    Collections.swap(L,i,j);
                }
            }
        }
        return L;
    }

    public static int getJob(String username){
        Connection con = connect2DB();
        CallableStatement cs = null;
        int jobId = 0;
        try {
            cs = con.prepareCall("{? = call getUserJob(?)}");
            int ind = 0;
            cs.registerOutParameter(++ind, Types.INTEGER);
            cs.setString(++ind, username);
            cs.execute();
            jobId = cs.getInt(1);
        }catch (Exception e){
            System.out.println(  e.getClass().getName() + ": " + e.getMessage() );
        }

        return jobId;
    }

    public static ArrayList<String> getClanUsers(int clanId) {
        Connection con = connect2DB();
        ArrayList<String> res = new ArrayList<String>();

        CallableStatement cs = null;

        try {
            cs = con.prepareCall("{call getClanUsers(?)}");
            cs.setInt(1,clanId);
            ResultSet rs = cs.executeQuery();
            while(rs.next()) {
                res.add(rs.getString(1));
            }
        } catch (Exception e) {
            System.out.println(e.getClass().getName() + ": " + e.getMessage());
        }
        return res;
    }

    public static ArrayList<ArrayList<String> > getClanBuildings(String clanId){
        ArrayList< ArrayList<String> > res = new ArrayList<ArrayList<String> >();
        Connection con = connect2DB();
        CallableStatement cs = null;
        int ind = 0;
        try {
            cs = con.prepareCall("{call getClanBuildings(?)}");
            ind = 0;
            cs.setInt(++ind, Integer.parseInt(clanId));
            ResultSet rs = cs.executeQuery();
            while(rs.next()) {
                ArrayList<String> tmp = new ArrayList<String>();
                tmp.add(String.format("%d", rs.getInt(1))); // ID
                tmp.add(rs.getString(2));   // Type
                tmp.add(rs.getDate(3).toString()); // DATE
                tmp.add(String.format("%d", rs.getInt(4)));      //PROGRESS
                int activity = rs.getInt(5);
                if (activity == 1) { // building is active
                    tmp.add("Deactivate");
                } else        // building is deactive
                    tmp.add("Activate");
                res.add(tmp);
            }

        }catch(Exception e) {
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }
        return res;
    }

    public static  ArrayList<ArrayList<String> > getAttacks( String clanId){
        ArrayList< ArrayList<String> > res = new ArrayList<ArrayList<String> >();
        Connection con = connect2DB();
        CallableStatement cs = null;
        int ind = 0;
        try {
            cs = con.prepareCall("{call getAttacks(?)}");
            ind = 0;
            cs.setInt(++ind, Integer.parseInt(clanId));
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                ArrayList<String> tmp = new ArrayList<String>();
                tmp.add(String.format("%d", rs.getInt(1))); // fight ID
                tmp.add(String.format("%d", rs.getInt(2))); // ClanID1
                tmp.add(String.format("%d", rs.getInt(3))); // ClanID2
                tmp.add(rs.getDate(4).toString()); // DATE

                res.add(tmp);
            }
        }catch (Exception e){
            System.out.println( e.getClass().getName() + ": " + e.getMessage() );
        }
        return res;
    }
}
