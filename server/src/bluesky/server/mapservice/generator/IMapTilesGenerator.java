package bluesky.server.mapservice.generator;

import bluesky.server.mapservice.IMap;

public interface IMapTilesGenerator {
    public void generate(IMap map);
}
