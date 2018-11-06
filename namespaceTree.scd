(
    var dataKeys = [\parameters];
    var elementKeys = dataKeys ++ [\controls];
    var
    ~graph = VTMDirectedIdentityGraph.newFromAdjacencyList([
        \networkNode --> [
            \scenes --> [
                \controls,
                \scenes,
                \modules,
                \devices
            ],
            \modules,
            \devices,
            \controls
        ]
    ]);
)

~graph.edges
