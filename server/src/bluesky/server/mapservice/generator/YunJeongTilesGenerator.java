package bluesky.server.mapservice.generator;

import bluesky.server.mapservice.IMap;

import java.util.Random;

public class YunJeongTilesGenerator implements IMapTilesGenerator {
    Random random = new Random();
    DecideTiles decideTiles = new DecideTiles();

    public class DecideTiles {
        int SOIL = 2;
        int GRASS = 3;
        int ROCK = 5;
        int IRON = 6;
        int GOLD = 7;
        int COIL = 8;
        int DIAMOND = 9;

        public double perSoil(int mapY) {
            return 1 - (mapY / 2);
        }

        public double perIron(int mapY) {
            double result = 1 / 5 * Math.log(mapY);
            if (result > 0.3) {
                return 0.3;
            } else {
                return result;
            }
        }

        public double perGold(int mapY) {
            double result = 1 / 10 * Math.log(Math.pow(mapY, 1 / 5));
            if (result > 0.01) {
                return 0.01;
            } else {
                return result;
            }
        }

        public double perCoil(int mapY) {
            double result = 1 / 5 * Math.log(mapY);
            if (result > 0.3) {
                return 0.3;
            } else {
                return result;
            }
        }

        public double perDiamond(int mapY) {
            double result = 1 / 10 * Math.log(Math.pow(mapY, 1 / 5));
            if (result > 0.01) return 0.01;
            return result;
        }


        int returnTiles(double randomNum, int mapY) {
            if (randomNum < perSoil(mapY)) {
                return SOIL;
            } else if (randomNum < perSoil(mapY) + perCoil(mapY)) {
                return COIL;
            } else if (randomNum < perSoil(mapY) + perCoil(mapY) + perIron(mapY)) {
                return IRON;
            } else if (randomNum < perSoil(mapY) + perCoil(mapY) + perIron(mapY) + perGold(mapY)) {
                return GOLD;
            } else if (randomNum < perSoil(mapY) + perCoil(mapY) + perIron(mapY) + perGold(mapY) + perDiamond(mapY)) {
                return DIAMOND;
            } else {
                return ROCK;
            }
        }
    }
    
    @Override
    public void generate(IMap map) {
        if(map.getMapY() == 0) {
            for (int y = 0; y < 10; y++) {
                for (int x = 0; x < 20; x++) {
                    map.setTile(x, y, (byte) 0);
                }
            }
            for (int y = 10; y < 20; y++) {
                for (int x = 0; x < 20; x++) {
                    map.setTile(x, y, (byte) 2);
                }
            }
        } else if(map.getMapY() < 0) {
            for(int y=0; y<20; y++) {
                for (int x = 0; x < 20; x++) {
                    map.setTile(x, y, (byte) decideTiles.returnTiles(random.nextDouble(), map.getMapY()));
                }
            }
        }
    }
}