typealias ResourceDestroyFunc = (Resource) -> Void

struct Resource {

	//var object: Object
	
	var destroy: ResourceDestroyFunc
	
	//var link: LinkedList<>
	
	/*
	struct wl_signal deprecated_destroy_signal;
	struct wl_client *client;
	void *data;
	int version;
	wl_dispatcher_func_t dispatcher;
	struct wl_priv_signal destroy_signal;
	*/
}
