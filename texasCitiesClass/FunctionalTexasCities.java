
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
public class FunctionalTexasCities {
    
    private static void initTheArray (ArrayList<texasCitiesClass> txcArray, ArrayList<String> cityCounties) throws FileNotFoundException,IOException {
        String [] values;
        String line = "";
        String path = System.getProperty("user.dir");
        texasCitiesClass txc;
        BufferedReader br = new BufferedReader (new FileReader(path+"/src/L02a Cityname_wo_headers.csv"));
        
        while ((line = br.readLine()) != null) {
            values = line.split(",");
            txc = new texasCitiesClass(values[0],values[1],Integer.parseInt(values[2]));
            txcArray.add(txc);
            cityCounties.add(txc.getCounty());
            
        }
        br.close();
    }
    
    private static void initTXT() {
        String fileName = "L02a_Functional_Output.txt";
        try {
            FileWriter fileWriter = new FileWriter(fileName);
            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
            bufferedWriter.write(String.format("%-16s%-16s%-16s%-16s%-16s%-16s","County","No. Cities","Total Pop","Ave Pop","Largest City","Population"));
            bufferedWriter.newLine();
            bufferedWriter.close();
        }
        catch(IOException ex) {
            System.out.println("Error writing to file '" + fileName + "'");
        }
    }
    
    private static void writeTXT(String county, int cityNum, int totalPop, int avgPop, int maxCity) {
        String fileName = "L02a_Functional_Output.txt";
        try {
            FileWriter fileWriter = new FileWriter(fileName, true);
            BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
            bufferedWriter.write(String.format("%-16s%-16d%-16d%-16d%-16s%-16d",county,cityNum,totalPop,avgPop,"Largest City",maxCity));
            bufferedWriter.newLine();
            bufferedWriter.close();
        }
        catch(IOException ex) {
            System.out.println("Error writing to file '" + fileName + "'");
        }
    }
    
    public static void main(String[] args) throws FileNotFoundException, IOException {
        ArrayList<texasCitiesClass> txcArray = new ArrayList<texasCitiesClass>();
        ArrayList<String> cityCounties = new ArrayList<String>();
        initTheArray(txcArray,cityCounties);
        initTXT();
                
        cityCounties.stream()
                .sorted((p1, p2) -> (p1).compareTo(p2)) //Sort Counties alphabetically
                .distinct()
                .forEach(p -> {
                    int num =   (int) txcArray.stream()
                            .filter(q->q.getCounty().equals(p)) // number of cities
                            .map(q->q.getPopulation())
                            .count();
                            
                    int pop = txcArray.stream()
                            .filter(q->q.getCounty().equals(p)) // total population
                            .map(q ->q.getPopulation())
                            .reduce(0, Integer::sum);
                    
                    int avg = pop/num; //average
        
                    int max = txcArray.stream()
                            .filter(q->q.getCounty().equals(p)) // max population city
                            .map(q ->q.getPopulation())
                            .reduce(0,Integer::max);
                
    
                    writeTXT(p, num, pop, avg, max);
                    System.out.println(p+"\t\t"+num+"\t"+pop+"\t"+avg+"\t"+max);
            });
        
     
    }
}
}
