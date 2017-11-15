App.Router = Backbone.Router.extend({

    routes: {
        'generate-random-town': 'GenerateRandomTown',
        '*path': 'GenerateRandomTown'
    },

    GenerateRandomTown: function(){
        var view = new App.Views.GenerateRandomTown();
        
        $('#main').html(view.render().el);
        
    }
    
});