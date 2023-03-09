public class FacetsWrapper {
    public String attributeType;
    public String nameOrId;
    public String facetType;
    public String displayType;
    public Integer displayRank;
    public String displayName;
    public List<cls_values> values;
    
    public class cls_values{
        public String nameOrId;
        public String facetType;
        public String displayType;
        public Integer displayRank;
        public String displayName;
        public String attributeType;
        public String type;	
        public Integer productCount;
    }
}