import web

urls = (
    '/(.*)', 'hello'
)
app = web.application(urls, globals())

class hello:        
    def POST(self):
        data = json.loads(web.data())
        print "Hello " + data + "!"

if __name__ == "__main__":
    app.run()