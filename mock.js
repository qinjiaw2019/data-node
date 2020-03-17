function mockRule() {
    return data = Mock.mock({
        'data|100':[{
            name:'@name',
            email:'@email'
        }]
    }).data
}
function main(){
   var data = mockRule()

    var restult = []
    var keys = []
    for(var i =0;i<data.length;i++){
        var item = []
        restult.push(item)
        for(var key in data[i]){
            item.push(data[i][key])
            if(i==0)keys.push(key)
        }
    }
    return JSON.stringify(restult)
}