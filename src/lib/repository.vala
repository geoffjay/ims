public errordomain Ims.RepositoryError {
    ITEM_AVAILABLE,
    CREATE,
    READ,
    UPDATE,
    DELETE
}

// TODO: Make abstract?
public class Ims.Repository<T> : GLib.Object {

// public class Ims.Repository<JSON.Serializable> ???
// public class Ims.Repository<Ims.Model> ???
// public class Ims.Repository<GLib.Object> ???

    private Gee.Map<string, T> cache;

    public bool is_initialized { get; private set; default = false; }

    // TODO: Connect to these in the data model whenever a new repo is added
    //
    // private Gee.Map<string, Ims.Repository> repositories;
    // private image_repo = new Ims.Repository<Ims.Image> ();
    // repositories.@set ("images", image_repo);
    // image_repo.item_created.connect (image_created_cb);
    // image_repo.item_updated.connect (image_updated_cb);
    // image_repo.item_deleted.connect (image_deleted_cb);

    public signal void item_created (string uuid);

    public signal void item_updated (string uuid);

    public signal void item_deleted (string uuid);

    public Repository () {
        debug ("Constructing a repository for %s objects", typeof (T).name ());
        cache = new Gee.HashMap<string, T> ();
    }

    public virtual string create () throws Ims.RepositoryError {
        var uuid = GLib.Uuid.string_random ();
        var type = typeof (T);

        /* XXX necessary ? */
        lock (cache) {
            var object = Object.@new (type);
            cache.set (uuid, object);
            if (!cache.has_key (uuid)) {
                throw new Ims.RepositoryError.CREATE (
                    "Failed to create new item"
                );
            }
        }

        debug ("Added new %s with UUID %s", type.name (), uuid);
        item_created (uuid);

        return uuid;
    }

    public virtual T? read<T> (string uuid) throws Ims.RepositoryError {
        /* FIXME: This kind of contradicts the nullable return type */
        if (!cache.has_key (uuid)) {
            throw new Ims.RepositoryError.ITEM_AVAILABLE (
                "Item with UUID %s doesn't exist", uuid
            );
        }

        T object = cache.get (uuid);

        return object;
    }

    public virtual void update (string uuid, T object) throws Ims.RepositoryError {
        if (!cache.has_key (uuid)) {
            throw new Ims.RepositoryError.ITEM_AVAILABLE (
                "Item with UUID %s doesn't exist", uuid
            );
        }

        item_updated (uuid);
    }

    public virtual void delete (string uuid) throws Ims.RepositoryError {
        if (!cache.has_key (uuid)) {
            throw new Ims.RepositoryError.ITEM_AVAILABLE (
                "Item with UUID %s doesn't exist", uuid
            );
        }

        lock (cache) {
            debug ("Deleting an item with UUID: %s", uuid);
            cache.unset (uuid);
            if (cache.has_key (uuid)) {
                throw new Ims.RepositoryError.DELETE (
                    "Failed to delete item"
                );
            }
        }

        item_deleted (uuid);
    }
}
