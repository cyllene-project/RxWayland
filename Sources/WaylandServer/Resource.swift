typealias ResourceDestroyFunc = (Resource) -> Void

struct Resource {

	var object: Object
	
	var destroy: ResourceDestroyFunc
	
	//var link: LinkedList<>
	
	struct wl_list link;
	/* Unfortunately some users of libwayland (e.g. mesa) still use the
	 * deprecated wl_resource struct, even if creating it with the new
	 * wl_resource_create(). So we cannot change the layout of the struct
	 * unless after the data field. */
	struct wl_signal deprecated_destroy_signal;
	struct wl_client *client;
	void *data;
	int version;
	wl_dispatcher_func_t dispatcher;
	struct wl_priv_signal destroy_signal;
}
