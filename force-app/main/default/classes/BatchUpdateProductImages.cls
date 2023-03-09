public with sharing class BatchUpdateProductImages implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id,NT_Pattern_Desc__c,Pattern_Desc__c, Product_Image_Global_Key_Identifier__c FROM Product2 WHERE NT_Pattern_Desc__c ' + 
                                        'NOT IN (\'SP RGS\', \'GRANDTREK AT1\', \'GRANDTREK AT2\', \'GRANDTREK AT20\', \'GRANDTREK AT23\', \'GRANDTREK AT25\', \'GRANDTREK AT3GM\', \'GRANDTREK AT5\', \'BC100\', \'DIREZZA DZ102\', \'GRANDTREK ST20\', \'SP10\', \'DIREZZA DZ101\', \'ENASAVE EC300\', \'ENASAVE EC300+\', \'GRANDTREK ST30\', \'GRANDTREK MT2\', \'GRANDTREK TG36\', \'GRANDTREK AT22\', \'AT3\', \'GRANDTREK PT3\', \'TG21\', \'GRANDTREK TG27\', \'GRANDTREK TG28\', \'GRANDTREK TG30\', \'GRANDTREK TG32\', \'GRANDTREK TG35\', \'GRANDTREK MT1\', \'GRANDTREK AT3G\', \'HTR900\', \'HTR A/S P01\', \'HTRH5\', \'HTRT5\', \'HTRV5\', \'HTRV6\', \'HTRZ3\', \'SP SPORT LM703\', \'SP SPORT FM800\', \'SP320\', \'SP431\', \'SP925\', \'SP FASTRESPONSE\', \'GRANDTREK PT2\', \'GRANDTREK PT2A\', \'Sincera SN832\', \'SP SPORT 7000\', \'SP SPORT LM704\', \'SP SPORT MAXX TT\', \'SP TGR\', \'SP44\', \'SP ENDURA\', \'SP SPORT 600\', \'SP11\', \'SP120\', \'SP160\', \'SP161\', \'SP163\', \'SP171\', \'SP175\', \'SP188\', \'SP22\', \'SP225\', \'SP231\', \'SP SPORT 270\', \'SP281\', \'SP31\', \'SP341\', \'SP391\', \'SP502\', \'SP571\', \'SP580A\', \'SP835\', \'SP882\', \'SP931\', \'ECONODRIVE\', \'SP LT-11\', \'SP LT3+\', \'SP LT36\', \'SP LT37\', \'SP LT5\', \'SP SPORT MAXX 101\', \'SP SPORT MAXX A1\', \'SP Sport Maxx Race\', \'SP SPORT 2050\', \'SP SPORT 9000\', \'SP SPORT MAXX\', \'SP SPORT MAXX 050+\', \'SP SPORT MAXX GT\', \'SP QUATTROMAXX XL\', \'SP RV-MAJOR TG3\', \'SP SPORT 01\', \'SP SPORT 2030\', \'SP SPORT 220\', \'SP SPORT 230\', \'SP SPORT 300\', \'SP SPORT 5050\', \'SP SPORT 560\', \'SP SPORT 6060\', \'SP SPORT 7000D\', \'SP BLURESPONSE\', \'SP SPORT MAXX 050\', \'SP SPORT MAXX GT 600\', \'SP SPORT MAXX RT\', \'SP TOURING T1\', \'SP TRAKGRIP\', \'SL717\', \'ST718\', \'ST719\', \'ST738\', \'ST768\', \'ST791\', \'ST908\', \'ST909\', \'STE\', \'GRANDTREK TG40\', \'SP431A\', \'SP811\', \'SP VAN01\', \'VANTREK V1\', \'Ziex ZE914\')');
    }

    public void execute(Database.BatchableContext bc, List<Product2> scope){
        Set<Id> proSet = new Set<Id>();
        for(Product2 pro2 : scope)
            proSet.add(pro2.Id);

        List<ProductMedia> oldProMedList = [SELECT Id, Name FROM ProductMedia WHERE ProductId IN :proSet];

        ProductMedia proMed = new ProductMedia();
        List<ProductMedia> proMedList = new List<ProductMedia>();

        for(Product2 pro : scope) {
            pro.Product_Image_Global_Key_Identifier__c = 'MCVBD4VGIXIRFY3EGYFN5WFYXZJA'; // change it
        
        proMed.ProductId = pro.Id;
        proMed.ElectronicMediaGroupId = '2mg4K000001gl6IQAQ';
        proMed.ElectronicMediaId = '20Y7E00000001g5UAA'; // change it
        proMedList.add(proMed);
        promed = new ProductMedia();

        proMed.ProductId = pro.Id;
        proMed.ElectronicMediaGroupId = '2mg4K000001gl6HQAQ';
        proMed.ElectronicMediaId = '20Y7E00000001g5UAA'; // change it
        proMedList.add(proMed);
        promed = new ProductMedia();
        }
        Database.update(scope,false);
        delete oldProMedList;
        insert proMedList;
    }

    public void finish(Database.BatchableContext bc){

    }
}