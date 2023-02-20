({
    gotoURL : function (component, id, apiName) {
        let recordURL = '/lightning/r/'+apiName+'/' +id +'/edit'
        window.open(recordURL, "_blank");
    },
})